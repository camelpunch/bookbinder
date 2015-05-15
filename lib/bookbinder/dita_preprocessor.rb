require_relative 'values/subnav'

module Bookbinder
  class DitaPreprocessor

    ACCEPTED_IMAGE_FORMATS = %w(png jpeg jpg svg gif bmp tif tiff eps)

    def initialize(dita_formatter, local_fs_accessor)
      @dita_formatter = dita_formatter
      @local_fs_accessor = local_fs_accessor
    end

    def preprocess(sections, output_locations, &block)
      sections.select(&:requires_preprocessing?).each do |section_under_process|
        block.call(section_under_process)
        generate_subnav(section_under_process,
                        output_locations.dita_subnav_template_path,
                        output_locations.subnavs_for_layout_dir)
        destination = output_locations.source_for_site_generator.join(section_under_process.directory)
        dita_formatter.format_html(section_under_process.path_to_repository, destination)
      end
    end

    private

    attr_reader :dita_formatter, :local_fs_accessor

    def generate_subnav(dita_section, dita_subnav_template_path, subnavs_dir)
      dita_subnav_template_text = local_fs_accessor.read(dita_subnav_template_path)

      tocjs_text = local_fs_accessor.read(File.join(dita_section.path_to_repository, 'index.html'))
      json_props_location = 'dita-subnav-props.json'
      props_file_location = File.join(subnavs_dir, json_props_location)

      subnav = dita_formatter.format_subnav(dita_section,
                                            dita_subnav_template_text,
                                            json_props_location,
                                            tocjs_text)

     local_fs_accessor.write text: subnav.json_links, to: props_file_location

     local_fs_accessor.write text: subnav.text,
                                       to: File.join(subnavs_dir, "dita_subnav.erb")
    end
  end
end
