require 'erb'
require 'ostruct'

module Dockly
  class BashBuilder
    SNIPPET_PATH = File.expand_path("../../../snippets", __FILE__)

    def self.generate_snippet_for(name, opts, defaults={})
      define_method(name) do |*args|
        zipped_array = opts.zip(args).flatten
        snippet = File.read(File.join(SNIPPET_PATH, "#{name}.erb"))
        hash = Hash[*zipped_array].delete_if { |_,v| v.nil? }
        data = defaults.merge(hash)
        ERB.new(snippet).result(binding)
      end
    end

    # Done
    generate_snippet_for :normalize_for_dockly, []
    generate_snippet_for :get_from_s3, [:s3_url, :output_path], { :output_path => "-" }
    generate_snippet_for :install_package, [:path]
    generate_snippet_for :get_and_install_deb, [:s3_url, :deb_path]
    generate_snippet_for :docker_import, [:repo, :tag], { :tag => "latest" }
    generate_snippet_for :file_docker_import, [:path, :repo, :tag]
    generate_snippet_for :file_diff_docker_import, [:base_image, :diff_image, :repo, :tag]
    generate_snippet_for :s3_diff_docker_import, [:base_image, :diff_image, :repo, :tag]
    generate_snippet_for :registry_import, [:repo, :tag], { :tag => "latest" }
  end
end
