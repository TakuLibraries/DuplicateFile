require 'thor'

module DuplicateFile
  class Command < Thor
    def list(root_path)
      file_groups = group_by_checksum(root_path)
      file_groups.each do |key, files|
        puts files.join(",")
      end
    end

    def clean(root_path)
      checksum_filepath_group = group_by_checksum(root_path)
      checksum_filepath_group.each do |checksum, filepathes|
        dupricate_pathes = filepathes[1..(filepathes.size - 1)] || []
        next if dupricate_pathes.empty?
        dupricate_pathes.each do |path|
          File.delete(path)
        end
        puts "original file:#{filepathes.first} delete file:#{dupricate_pathes.join(",")}"
      end
    end

    private
    def group_by_checksum(root_path)
      all_files = Dir.glob(root_path + "**/*").select{|path| File.file?(path) }
      return all_files.group_by{|path| Digest::MD5.file(path).to_s }
    end
  end
end