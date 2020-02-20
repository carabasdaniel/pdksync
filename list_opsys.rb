#!/bin/env/ruby

require 'json'
require 'erb'

directory = ARGV[0]

temp = ERB.new <<-EOF
  <table>
    <tr>
      <th>Module</th>
      <th>OS</th>
      <th>Versions</th>
    </tr>
    <% results.each do |item| %>
    <tr>
    <td> <%= item[:name] %> </td>
    <td> <%= item[:os] %> </td>
    <td align="center"> <%= item[:versions] %> </td>
    </tr>
    <% end %>   
  </table>
EOF

results = []

Dir.glob("#{directory}/**/metadata.json") do |filename|
  begin
 # puts filename
  content = File.read(filename)
  data = JSON.parse(content.gsub('\"','"'))
 # puts data['operatingsystem_support']
  data['operatingsystem_support'].each do |info|
	  results << { :name => filename.split('/')[1], :os => info['operatingsystem'], :versions => info['operatingsystemrelease'] }
  end
  rescue
    puts "FAIL for #{filename}"
  end

  File.open('oses.html','w') do |f|
    f.write temp.result(binding)
  end

end
