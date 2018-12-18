Records        = require 'shared/services/records'
EventBus       = require 'shared/services/event_bus'
AbilityService = require 'shared/services/ability_service'

module.exports = Vue.component 'DocumentList',
  props:
    model: Object
    showEdit: Boolean
    hidePreview: Boolean
    hideDate: Boolean
    skipFetch: Boolean
    placeholder: String
  created: ->
    Records.documents.fetchByModel(@model) unless @model.isNew() or @skipFetch
    view = Records.documents.collection.addDynamicView("#{model.singluar}_#{model.id}_documents")
    # view.addFind()
  data: ->
    allDocuments: Loomio.records.documents.collection.data
  methods:
    edit: (doc, $mdMenu) ->
      EventBus.broadcast @, 'initializeDocument', doc, $mdMenu
  computed:
    orderedDocuments: =>
      _.orderBy(@model.newAndPersistedDocuments(), ['-createdAt'])

    showTitle: ->
      (@model.showDocumentTitle or @showEdit) and
      (@model.hasDocuments() or @placeholder)
  template:
    """
      <section class="document-list">
        <h3
          v-if="showTitle"
          v-t="{ path: 'document.list.title' }"
          class="document-list__heading lmo-card-heading"
        ></h3>
        <p
          v-if="!model.hasDocuments() && placeholder"
          v-t="placeholder"
          class="lmo-hint-text md-caption"
        ></p>
        <div
          layout="column"
          class="document-list__documents md-block lmo-flex"
        >
          <div
            layout="column"
            :class="{'document-list__document--image': document.isAnImage() && !hidePreview}"
            v-for="document in orderedDocuments"
            :key="document.id"
            class="document-list__document lmo-flex"
          >
            <div
              v-if="document.isAnImage() && !hidePreview"
              class="document-list__image"
            >
              <a
                :href="document.url"
                target="_blank"
                class="lmo-pointer"
              >
                <img
                  :src="document.webUrl"
                  :alt="document.title"
                >
              </a>
            </div>
            <div
              layout="row"
              class="document-list__entry lmo-flex lmo-flex__center"
            >
              <i
                :class="`mdi lmo-margin-right mdi-${document.icon}`"
                :style="{color: document.color}"
              ></i>
              <a
                :href="document.url"
                target="_blank"
                class="lmo-pointer lmo-relative lmo-truncate lmo-flex lmo-flex__grow"
              >
                <div
                  class="document-list__title lmo-truncate lmo-flex__grow"
                >
                  {{ document.title }}
                </div>
              </a>
              <div
                v-if="!hideDate && !showEdit"
                class="document-list__upload-time md-caption lmo-flex__shrink"
              >
                {{ document.createdAt.fromNow() }}
              </div>
              <!-- <document_list_edit
                document="document"
                ng-if="showEdit"
              ></document_list_edit> -->
              <button
                v-if="showEdit"
                @click="$emit(\'documentRemoved\', document)"
                class="md-button--tiny"
              >
                <i class="mdi mdi-close"></i>
              </button>
            </div>
          </div>
        </div>
      </section>
    """
