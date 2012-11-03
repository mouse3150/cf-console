require 'zip/zipfilesystem'

module CFCZIP

  class ZipUtil
    PACK_EXCLUSION_GLOBS = ['..', '.', '*~', '#*#', '*.log']
    class << self
      def entry_lines(file)
        contents = nil
        unless contents
          entries = []
          Zip::ZipFile.foreach(file) { |zentry| entries << zentry }
          contents = entries.join("\n")
        end
        contents
      end

      def unpack(file, dest)
        Zip::ZipFile.foreach(file) do |zentry|
          epath = "#{dest}/#{zentry}"
          dirname = File.dirname(epath)
          FileUtils.mkdir_p(dirname) unless File.exists?(dirname)
          zentry.extract(epath) unless File.exists?(epath)
        end
      end

      def get_files_to_pack(dir)
        Dir.glob("#{dir}/**/*", File::FNM_DOTMATCH).select do |f|
          process = true
          PACK_EXCLUSION_GLOBS.each { |e| process = false if File.fnmatch(e, File.basename(f)) }
          process && File.exists?(f)
        end
      end

      def pack(dir, zipfile)
        Zip::ZipFile::open(zipfile, true) do |zf|
          get_files_to_pack(dir).each do |f|
            zf.add(f.sub("#{dir}/",''), f)
          end
        end
      end
      
    end
  end
end
