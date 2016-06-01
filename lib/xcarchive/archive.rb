require 'plist'

class Archive
	ARCHIVES_ROOT = File.join(File.expand_path('~'), "Library/Developer/Xcode/Archives")

	def self.all_archives()
		all_archives = Array.new
		Dir[File.join(Archive::ARCHIVES_ROOT, '*')].each do |archives|
			Dir[File.join(archives, '*.xcarchive')].each do |file|
				archive = Archive.new(file)
				all_archives.push(archive)
			end
		end
		return all_archives
	end

	def self.filtered_archives(bundle = nil, version = nil, build = nil)
		archives = Archive::all_archives
		if bundle != nil then
			archives = archives.select { |x| x.bundle_id == bundle }
		end
		if version != nil then
			archives = archives.select { |x| x.version == version }
		end
		if build != nil then
			archives = archives.select { |x| x.build == build }
		end
		return archives
	end

	attr_reader :path

	def initialize(path)
		@path = path
		@info = nil
	end

	def info_file
		return File.join(self.path, "Info.plist")
	end

	def info
		if @info == nil then
			@info = Plist::parse_xml(self.info_file)
		end
		return @info
	end

	def bundle_id
		return self.info['ApplicationProperties']['CFBundleIdentifier']
	end

	def build
		return self.info['ApplicationProperties']['CFBundleVersion']
	end

	def version
		return self.info['ApplicationProperties']['CFBundleShortVersionString']
	end

	def archived_on
		return self.info['CreationDate']
	end

	def name
		return self.info['Name']
	end

	def description
		str = "=================================================\n"
		str << "Name: #{self.name}\n"
		str << "Bundle ID: #{self.bundle_id}\n"
		str << "Version: #{self.version}\n"
		str << "Build: #{self.build}\n"
		str << "Archived On: #{self.archived_on}\n"
		str << "Path: #{self.path}\n"
		return str
	end

	def export(path, options)
		if system("xcodebuild -exportArchive -exportOptionsPlist \"#{options}\" -archivePath \"#{self.path}\" -exportPath \"#{path}\" &> /dev/null")
			return File.join(path, "#{self.name}.ipa")
		else
			return nil
		end
	end
end

