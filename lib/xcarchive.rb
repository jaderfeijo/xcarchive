require "xcarchive/version"
require "xcarchive/archive"

require 'optparse'
require 'ostruct'

module Xcarchive
	def run
		options = OpenStruct.new
		OptionParser.new do |opts|
			opts.banner = "Usage: xcarchive [options]"

			opts.separator ""
			opts.separator "Specific options:"

			options.path = false
			opts.on("-p", "--path", "Print archive paths only") do
				options.path = true
			end

			options.list = false
			opts.on("-l", "--list", "List all builds in a human readable format") do
				options.list = true
			end

			options.export = nil
			opts.on("-e", "--export PATH", "Export an archive into the given path") do |path|
				options.export = path
			end

			options.id = nil
			opts.on("--id IDENTIFIER", "Limits the output to archives for the app with the specified bundle identifier") do |id|
				options.id = id
			end

			options.version = nil
			opts.on("--version VERSION", "Limits the output to archives matching the specified version") do |version|
				options.version = version
			end

			options.build = nil
			opts.on("--build BUILD", "Limits the output to archives matching the specified build number") do |build|
				options.build = build
			end

			options.options = nil
			opts.on("--options OPTIONS", "Specifies the export options file to be used when exporting builds") do |opt|
				options.options = opt
			end

			opts.on_tail("-h", "--help", "Show this message") do
				puts opts
				puts
				exit 1
			end
		end.parse!

		if !options.path && !options.list && !options.export then
			puts "You must specify at least one of the following options:"
			puts "  --path, --list, --export"
			puts
			puts "Type xcarchive --help for more information"
			puts
			exit 1
		end

		archives = Archive::filtered_archives(options.id, options.version, options.build)
		if archives.count <= 0 then
			puts "No archives found."
			exit 1
		end

		if options.path && !options.list && !options.export then
			archives.each do |archive|
				puts archive.path
			end
		elsif options.list && !options.path && !options.export then
			archives.each do |archive|
				puts archive.description
			end
			puts "================================================="
			puts "Total #{archives.count} archives found."
			puts "================================================="
		elsif options.export && !options.path && !options.list then
			if options.options == nil then
				puts "You must specify the xcode export options file to use:"
				puts "	--options OPTIONS_FILE"
				puts
				exit 1
			end

			archives.each do |archive|
				puts archive.export(options.export, options.options)
			end
		else
			puts "You must not specify more than one of the following options:"
			puts "	--path, --list, --export"
			puts
			exit 1
		end

		exit 0
	end
end
