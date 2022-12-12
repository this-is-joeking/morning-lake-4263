require 'rails_helper'

RSpec.describe 'projects show' do
  it 'shows the projects name, material and theme of challenge' do
    recycled_material_challenge = Challenge.create!(theme: 'Recycled Material', project_budget: 1000)
    furniture_challenge = Challenge.create!(theme: 'Apartment Furnishings', project_budget: 1000)
    news_chic = recycled_material_challenge.projects.create!(name: 'News Chic', material: 'Newspaper')
    boardfit = recycled_material_challenge.projects.create!(name: 'Boardfit', material: 'Cardboard Boxes')

    visit "/projects/#{news_chic.id}"

    expect(page).to have_content(news_chic.name)
    expect(page).to have_content(news_chic.material)
    expect(page).to have_content(recycled_material_challenge.theme)
  end

  it 'shows a count of the number of contestants on the project' do
    recycled_material_challenge = Challenge.create(theme: 'Recycled Material', project_budget: 1000)
    boardfit = recycled_material_challenge.projects.create(name: 'Boardfit', material: 'Cardboard Boxes')
    jay = Contestant.create(name: 'Jay McCarroll', age: 40, hometown: 'LA', years_of_experience: 13)
    gretchen = Contestant.create(name: 'Gretchen Jones', age: 36, hometown: 'NYC', years_of_experience: 12)
    kentaro = Contestant.create(name: 'Kentaro Kameyama', age: 30, hometown: 'Boston', years_of_experience: 8)
    ContestantProject.create(contestant_id: jay.id, project_id: boardfit.id)
    ContestantProject.create(contestant_id: gretchen.id, project_id: boardfit.id)
    ContestantProject.create(contestant_id: kentaro.id, project_id: boardfit.id)

    visit "/projects/#{boardfit.id}"

    expect(page).to have_content('Number of Contestants: 3')
  end

  it 'shows the average years of experience for contestants on the project' do
    recycled_material_challenge = Challenge.create(theme: 'Recycled Material', project_budget: 1000)
    boardfit = recycled_material_challenge.projects.create(name: 'Boardfit', material: 'Cardboard Boxes')
    jay = Contestant.create(name: 'Jay McCarroll', age: 40, hometown: 'LA', years_of_experience: 13)
    gretchen = Contestant.create(name: 'Gretchen Jones', age: 36, hometown: 'NYC', years_of_experience: 12)
    kentaro = Contestant.create(name: 'Kentaro Kameyama', age: 30, hometown: 'Boston', years_of_experience: 8)
    ContestantProject.create(contestant_id: jay.id, project_id: boardfit.id)
    ContestantProject.create(contestant_id: gretchen.id, project_id: boardfit.id)
    ContestantProject.create(contestant_id: kentaro.id, project_id: boardfit.id)

    visit "/projects/#{boardfit.id}"

    expect(page).to have_content('Average Contestant Experience: 11.0 years')
  end

  it 'has a field for adding a contestant to project using contestants id' do
    recycled_material_challenge = Challenge.create(theme: 'Recycled Material', project_budget: 1000)
    boardfit = recycled_material_challenge.projects.create(name: 'Boardfit', material: 'Cardboard Boxes')
    jay = Contestant.create(name: 'Jay McCarroll', age: 40, hometown: 'LA', years_of_experience: 13)
    gretchen = Contestant.create(name: 'Gretchen Jones', age: 36, hometown: 'NYC', years_of_experience: 12)
    ken = Contestant.create(name: 'Ken Kam', age: 30, hometown: 'Boston', years_of_experience: 8)
    ContestantProject.create(contestant_id: jay.id, project_id: boardfit.id)
    ContestantProject.create(contestant_id: gretchen.id, project_id: boardfit.id)

    visit "/projects/#{boardfit.id}"

    expect(page).to have_content('Number of Contestants: 2')

    fill_in('ContestantID', with: ken.id)
    click_button('Add Contestant To Project')

    expect(current_path).to eq("/projects/#{boardfit.id}")
    expect(page).to have_content('Number of Contestants: 3')

    visit '/contestants'

    within("div##{ken.id}") do
      expect(page).to have_content(boardfit.name)
    end
  end
end
