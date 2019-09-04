#!/usr/local/opt/ruby/bin/ruby
#!/usr/local/bin/ruby

require 'ruby-jss'
require 'optparse'
require 'rexml/document'
include REXML

$options = {}

OptionParser.new do |opts|
    opts.banner = "Usage: sync.rb [options]"

    opts.on("-v", "--[no-]verbose", "Run verbosely")
    opts.on("-p", "--password [String]", String, "Jamf API account password")
    opts.on("-u", "--username [String]", String, "Jamf API account username")
    opts.on("--url [String]", String, "Jamf Pro Server URL")
    opts.on("--last_commit [String]", String, "Commit to find differences from.")
    opts.on("-h", "--help", "Print usage information.") do |h|
        puts opts
        exit 0
    end

end.parse!(into: $options)

def differences
    last_commit = `git log -l --pretty=oneline --pretty=format:\"%h\"`
    last_commit = (last_commit.split /\r?\n/)[0]
    differences = `git diff --name-only #{$options[:last_commit]} #{last_commit}`
    differences = differences.split /\r?\n/

    scripts = differences.grep /^scripts/
    eas = differences.grep /^extension_attributes/

    return {scripts: scripts, extension_attributes: eas}
end

def sync_scripts(scripts)
    script_names = scripts.map { |x| (x.split /\//)[1] }
    script_names = script_names.uniq

    script_names.each do |script_name|
        script = ""
        begin
            script = JSS::Script.fetch name: script_name
        rescue JSS::NoSuchItemError => e
            script = JSS::Script.make name: script_name
        end

        puts "Setting code of #{script_name}..."
        begin
            script_code = File.read("scripts/#{script_name}/script.sh")
        rescue Errno::ENOENT => e
            script_code = File.read("scripts/#{script_name}/script.py")
        end

        puts "Getting preferences of #{script_name}..."
        xmldata = File.read("scripts/#{script_name}/script.xml")
        xmldoc = Document.new xmldata

        xmldoc.root.elements.each do |e|
            if e.name == "name"
                script.filename = e.get_text.value
            elsif e.name == "category"
                script.category = e.get_text.value
            elsif e.name == "info"
                if e.get_text.nil?
                    script.info = nil
                else
                    script.info = e.get_text.value
                end
            elsif e.name == "notes"
                if e.get_text.nil?
                    script.notes = nil
                else
                    script.notes = e.get_text.value
                end
            elsif e.name == "priority"
                script.notes = e.get_text.value
            elsif e.name == "parameters"
                
                [4,5,6,7,8,9,10,11].each do |x|
                    script.set_parameter x, nil
                end

                if e.get_text.nil?
                    #   Parameters already cleared, so just going to next element
                    next
                else
                    e.elements.each do |e|
                        if e.name == "parameter4"
                            script.set_parameter 4, e.get_text.value
                        elsif e.name == "parameter5"
                            script.set_parameter 5, e.get_text.value
                        elsif e.name == "parameter6"
                            script.set_parameter 6, e.get_text.value
                        elsif e.name == "parameter7"
                            script.set_parameter 7, e.get_text.value
                        elsif e.name == "parameter8"
                            script.set_parameter 8, e.get_text.value
                        elsif e.name == "parameter9"
                            script.set_parameter 9, e.get_text.value
                        elsif e.name == "parameter10"
                            script.set_parameter 10, e.get_text.value
                        elsif e.name == "parameter11"
                            script.set_parameter 11, e.get_text.value
                        end
                    end
                end
            elsif e.name == "os_requirements"
                if e.get_text.nil?
                    #   Clear os requirements
                else
                    e.elements.each do |e|
                        puts e.name
                    end
                end
            else
                puts "Unknown name: #{e.name}!"
            end

        script.code = script_code
        script.save
        end
        
    end
end

def sync_extension_attributes(eas)
    puts eas
end

#puts $options.to_s

JSS.api.connect server: $options[:url], user: $options[:username], pw: $options[:password]

sync_scripts differences[:scripts]

exit 0
