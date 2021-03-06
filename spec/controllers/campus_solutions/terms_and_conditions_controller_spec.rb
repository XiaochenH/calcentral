describe CampusSolutions::TermsAndConditionsController do

  let(:user_id) { '61889' }

  context 'updating terms and conditions' do
    it 'should not let an unauthenticated user post' do
      post :post, {format: 'json', uid: '100'}
      expect(response.status).to eq 401
    end

    context 'authenticated user' do
      before do
        session['user_id'] = user_id
        User::Auth.stub(:where).and_return([User::Auth.new(uid: user_id, is_superuser: false, active: true)])
      end
      it 'should let an authenticated user post' do
        post :post,
             {
               bogus_field: 'abc',
               response: 'Y',
               aidYear: '2019'
             }
        expect(response.status).to eq 200
        json = JSON.parse(response.body)
        expect(json['statusCode']).to eq 200
        expect(json['feed']).to be
        expect(json['feed']['institution']).to eq 'UCB01'
      end
      it 'should reject a post that fails validation' do
        post :post,
            {
              response: 'Y',
              aidYear: '2001'
            }
        expect(response.status).to eq 400
        json = JSON.parse(response.body)
        expect(json['feed']).not_to be
        expect(json['error']).to be
      end
    end
  end
end
