puts '// this file is autogenerated by a lineman grunt task, so don\' expect your edits to stay'
Dir[ File.join('../modules', '**', '*.scss') ].each do |filename|
  puts "@import '#{filename}';" unless filename =~ /settings/
end
Dir[ File.join('../components', '**', '*.scss') ].each do |filename|
  puts "@import '#{filename}';" unless filename =~ /settings/
end
