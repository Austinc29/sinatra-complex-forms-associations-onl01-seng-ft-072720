require 'spec_helper'

describe "Owners Controller" do
  describe "new action" do 

    it "can visit '/owners/new'" do
      get '/owners/new'
      expect(last_response.status).to eq(200)
    end

    it "'/owners/new' loads form to create a new owner" do
      visit '/owners/new'
      expect(page).to have_field('owner[name]')
    end

    it "'/owners/new' form has a checkbox for existing pets" do
      @pet1 = Pet.create(:name => "Bessie")
      @pet2 = Pet.create(:name => "Sadie")
      visit '/owners/new'
      expect(page.has_unchecked_field?(@pet1.id)).to eq(true)
      expect(page.has_unchecked_field?(@pet2.id)).to eq(true)
    end



    it "'/owners/new' creates a new owner and associates an existing pet " do
      @pet1 = Pet.create(:name => "Bessie") 
      @pet2 = Pet.create(:name => "Sadie")
      visit '/owners/new'
      fill_in "owner[name]", :with => "Sophie"
      check(@pet1.id)
      click_button "Create Owner"
      @owner = Owner.last
      expect(@owner.name).to eq("Sophie")
      expect(@owner.pets.first.name).to eq("Bessie")
    end

  describe "edit action" do 
    before(:each) do
      @owner = Owner.create(:name => "Carla")
      @pet = Pet.create(:name => "Chewie", :owner_id => @owner.id)
    end
  end 

    

    it "edit's the owner's pets with an existing pet" do
      @shaggy = Pet.create(:name => "Shaggy")
      visit "/owners/#{@owner.id}/edit"
      check(@shaggy.id)
      click_button "Update Owner"
      expect(Owner.last.pets.last.name).to eq("Shaggy")
    end

    it "edit's the owner's pets with a new pet" do
      visit "/owners/#{@owner.id}/edit"
      fill_in "pet[name]", :with => "Carlton"
      click_button "Update Owner"
      expect(Owner.last.pets.last.name).to eq("Carlton")
    end
  end
end
