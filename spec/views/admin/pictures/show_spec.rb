require "spec_helper"

describe "alchemy/admin/pictures/show.html.erb" do
  let(:image) do
    fixture_file_upload(
      File.expand_path('../../../../fixtures/animated.gif', __FILE__),
      'image/gif'
    )
  end

  let(:picture) do
    build_stubbed(:alchemy_picture, {
      image_file: image,
      name: 'animated',
      image_file_name: 'animated.gif'
    })
  end

  before do
    allow(view).to receive(:admin_picture_path).and_return("/path")
    allow(view).to receive(:_t) {}
    allow(view).to receive(:render_message) {}
    view.extend Alchemy::Admin::FormHelper
  end

  it "displays picture in original format" do
    assign(:picture, picture)
    assign(:pages, [])

    render

    expect(rendered).to have_selector('img[src*="gif"]')
  end

  it "separates the tags with a comma" do
    allow(picture).to receive(:tag_list).and_return(["one", "two", "three"])
    assign(:picture, picture)
    assign(:pages, [])

    render

    expect(rendered).to have_selector('input[value*="one,two,three"]')
  end
end
