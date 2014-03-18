require 'spec_helper'

describe Book do
  include_context 'tmp_dirs'

  let(:constituents) do
    [{"github_repo" => "fantastic/dogs-repo", "directory" => "dogs"}]
  end

  let(:book_name) { 'wow-org/such-book' }

  describe '#tag_self_and_constituents_with' do
    let(:desired_tag) { 12.times.map { (65 + rand(26)).chr }.join  }

    it 'should tag itself and the constituent repos' do
      constituents.each do |c|
        doc_repo = double
        expect(Repository).to receive(:new).with(full_name: c['github_repo']).and_return(doc_repo)
        expect(doc_repo).to receive(:tag_with).with(desired_tag)
      end

      self_repo = double
      expect(Repository).to receive(:new).with(full_name: book_name, target_ref: nil, github_token: nil).and_return(self_repo)
      expect(self_repo).to receive(:tag_with).with(desired_tag)

      book = Book.new(full_name: book_name, constituent_params: constituents)
      book.tag_self_and_constituents_with(desired_tag)
    end
  end

  describe '.from_remote' do
    let(:temp_workspace) { tmp_subdir('workspace') }
    let(:ref) { 'this-is-a-tag' }
    let(:full_name) { 'foo/book' }

    before { stub_github_for full_name, ref }

    it 'unzips an archive at the given path' do
      Book.from_remote(full_name: 'foo/book', destination_dir: temp_workspace, ref: ref)
      File.exists?(File.join(temp_workspace, 'book', 'config.yml')).should be_true
    end
  end
end
