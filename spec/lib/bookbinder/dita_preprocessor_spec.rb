require_relative '../../../lib/bookbinder/dita_preprocessor'
require_relative '../../../lib/bookbinder/values/output_locations'
require_relative '../../../lib/bookbinder/values/section'

module Bookbinder
  describe DitaPreprocessor do
    it "generates a subnav and copies images" do
      formatter = double('formatter')
      fs = double('filesystem')
      processor = DitaPreprocessor.new(formatter, fs)

      sections = [
        Section.new(path = '/path/to/dita-repo', repo_name = nil, copied = true,
                    dest_dir = '', dir_name = 'desired-dir', subnav_templ = 'some-template-path',
                    preprocessor_config = {})
      ]

      locations = OutputLocations.new(
        context_dir: 'context/dir',
        final_app_dir: nil,
        layout_repo_dir: nil,
        local_repo_dir: nil
      )

      allow(fs).to receive(:read).with(locations.dita_subnav_template_path) { 'the template text' }
      allow(fs).to receive(:read).with('/path/to/dita-repo/index.html') { 'the tocjs content' }

      allow(formatter).to receive(:format_subnav).
        with(sections[0],
             'the template text',
             'dita-subnav-props.json',
             'the tocjs content') { Subnav.new('some links', 'some text') }

      allow(fs).to receive(:find_files_with_ext).with(anything, Pathname("/path/to/dita-repo")) { ['an-image'] }

      expect(fs).to receive(:write).with(
        text: "some links",
        to: "context/dir/output/master_middleman/source/subnavs/dita-subnav-props.json"
      )

      expect(fs).to receive(:write).with(
        text: "some text",
        to: "context/dir/output/master_middleman/source/subnavs/dita_subnav.erb"
      )

      expect(formatter).to receive(:format_html).with(
        Pathname("/path/to/dita-repo"),
        Pathname("context/dir/output/master_middleman/source/desired-dir")
      )

      received_sections = []
      processor.preprocess(sections, locations) do |section|
        received_sections << section
      end

      expect(received_sections).to eq(sections)
    end
  end
end

