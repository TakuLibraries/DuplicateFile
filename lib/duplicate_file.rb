require "duplicate_file/command"
require "duplicate_file/version"

module DuplicateFile
  def self.group_by_checksum(root_path)
    all_files = Dir.glob(root_path + "**/*").select{|path| File.file?(path) }
    all_files.group_by{|path| Digest::MD5.file(path).to_s }
  end

  def self.unique!(root_path)
    stay_pathes = []
    deleted_pathes = []
    checksum_filepath_group = group_by_checksum(root_path)
    checksum_filepath_group.each do |checksum, filepathes|
      dupricate_pathes = filepathes[1..(filepathes.size - 1)] || []
      stay_pathes << filepathes.first
      dupricate_pathes.each do |path|
        deleted_pathes << path
        File.delete(path)
      end
    end
    return stay_pathes.uniq, deleted_pathes
  end
end
