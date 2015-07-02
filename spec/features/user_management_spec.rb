feature 'User sign up' do

  scenario 'can sign up as a new user' do
    expect { sign_up }.to change(User, :count).by(1)
    expect(page).to have_content('Welcome, alice@example.com')
    expect(User.first.email).to eq('alice@example.com')
  end

  def sign_up(email: 'alice@example.com', password: 'oranges!')
    visit '/users/new'
    expect(page.status_code).to eq(200)
    fill_in :email, with: email # doesn't matter if email is a string or symbol?
    fill_in :password, with: password
    click_button 'Sign up'
  end
end