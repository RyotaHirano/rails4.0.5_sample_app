require 'spec_helper'

describe "MicropostPages" do
  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "micropost creation" do
    before { visit root_path }

    describe "with invalid information" do

      it "should not create a micropost" do
        expect { click_button "Post" }.not_to change(Micropost, :count)
      end

      describe "error messages" do
        before { click_button "Post" }
        it { should have_content('error') }
      end
    end

    describe "with valid information" do

      before { fill_in 'micropost_content', with: "Lolem ipsum" }
      it "should create a micropost" do
        expect { click_button "Post" }.to change(Micropost, :count).by(1)
      end

      describe "and post 1 micropost" do
        before { click_button "Post" }

        it { should have_content('1 micropost') }
        it { should_not have_content('1 microposts') }
      end

      describe "and post 2 microposts" do
        before do
          click_button "Post"
          fill_in "micropost_content", with: "hoge"
          click_button "Post"
        end

        it { should have_content('2 microposts') }
      end
    end
  end

  describe "micropost destruction" do
    before { FactoryGirl.create(:micropost, user: user) }

    describe "as correct user" do
      before { visit root_path }

      it "should delete a micropost" do
        expect { click_link "delete" }.to change(Micropost, :count).by(-1)
      end
    end

    describe "as incorrect user" do
      let(:incorrect_user) { FactoryGirl.create(:user) }

      before do
        FactoryGirl.create(:micropost, user: incorrect_user)
        visit user_path(incorrect_user)
      end

      it { should_not have_link('delete') }
    end
  end

  describe "pagination" do
    before do
      50.times { FactoryGirl.create(:micropost, user: user) }
      visit root_path
    end
    after { Micropost.delete_all }

    it { should have_selector('div.pagination') }
  end
end
