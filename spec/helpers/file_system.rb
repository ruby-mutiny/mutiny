module Helpers
  module FileSystem
    def clean_tmp_dir
      FileUtils.rm_rf(path)
      FileUtils.mkdir_p(path("lib"))
      FileUtils.mkdir_p(path("spec"))
    end

    def read(filename)
      File.read(path(filename))
    end

    def write(filename, content)
      dirname = File.dirname(path(filename))
      FileUtils.mkdir_p(dirname) unless File.directory?(dirname)
      File.open(path(filename), "w") { |f| f.write(content) }
    end

    def path(filename = "")
      File.expand_path("../../../.tmp/#{filename}", __FILE__)
    end
  end
end
