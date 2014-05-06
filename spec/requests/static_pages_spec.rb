require 'spec_helper'

describe "StaticPages" do

  subject { page }

  shared_examples_for "all static pages" do
    it { should have_selector('h1', text: heading) }
    it { should have_title(page_title) }
  end


  describe "Home page" do
    before { visit root_path }
    let(:heading)    { 'Αρχική Σελίδα' }
    let(:page_title) { 'Αρχική Σελίδα' }
    it { should have_content('Καλωσήρθατε στην Πτυχιακή εργασία μου') }
    it_should_behave_like "all static pages"
  end

  describe "Contact page" do
    before { visit contact_path }
    let(:heading)    { 'Επικοινωνία' }
    let(:page_title) { 'Επικοινωνία' }

    it_should_behave_like "all static pages"
  end
end
