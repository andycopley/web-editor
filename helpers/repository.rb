require 'find'
require 'pathname'
require 'git'
require 'octokit'

require_relative 'jsonable'

module AwestructWebEditor
  class Repository
    include AwestructWebEditor::JSONable

    attr_reader :name, :uri
    attr_accessor :relative_path

    def initialize(content = [])
      @name = content['name'] || ''
      @uri = content['uri'] || ''
      @relative_path = content['relative_path'] || nil
      @base_repo_dir = content['base_repo_dir'] || ENV['RACK_ENV'] == 'test' ? 'tmp' : 'repos'
    end

    def all_files(ignores = [])
      base_repository_path = File.join @base_repo_dir, @name
      default_ignores = %w(.gitignore .git _site .awestruct .awestruct_ignore _config _ext .git .travis.yml)
      default_ignores << ignores.join unless ignores.empty?
      regexp_ignores = Regexp.union default_ignores
      files = []

      Find.find(base_repository_path) do |path|
        if regexp_ignores.match(path.to_s)
          Find.prune
        else
          unless File.basename(path.to_s) == @name
            files << {:location => File.basename(path), :directory => File.directory?(path),
                      :path_to_root => Pathname.new(path).relative_path_from(Pathname.new base_repository_path).dirname.to_s}

          end
        end
      end
      files
    end

    def save_file(name, content)

    end

    def commit(subject, body)

    end

  end
end