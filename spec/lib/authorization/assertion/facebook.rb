require 'rails_helper'

RSpec.describe Authorization::Assertion::Facebook do
  let(:facebook_responce) do
    '{
      "id": "1659565134412042",
      "name": "Che Guevara",
      "email": "che@guevara.com",
      "first_name": "Che",
      "last_name": "Guevara",
      "gender": "male",
      "friends": {
        "data": [
          {
            "name": "Fidel Castro",
            "id": "10204220238175291"
          }
        ],
        "summary": {
          "total_count": 2
        }
      }
    }'
  end
  let(:facebook_auth) do
    stub_request(:get, "https://graph.facebook.com/v2.5/me?access_token=any%20token&fields=id,name,email,first_name,last_name,gender,friends").
      with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host'=>'graph.facebook.com', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => facebook_responce, :headers => {})
    Authorization::Assertion::Facebook.new('any token')
  end

  describe "#get_user" do
    let!(:user) { create :user, facebook_id: '1659565134412042' }

    subject { facebook_auth.get_user! }

    it "should return user" do
      expect(subject).to eq(user)
    end
  end

  describe "#friends" do
    let!(:user) { create :user, facebook_id: '1659565134412042' }
    let!(:friend) { create :user, facebook_id: '10204220238175291' }

    before { facebook_auth.friends }

    subject { user.friends }

    it 'should have friend' do
      expect(subject).to include(friend)
    end
  end
end
