require 'spec_helper'

describe CampusSolutions::PhoneController do
  context 'updating phone' do
    it 'should not let an unauthenticated user post' do
      post :post, {format: 'json', uid: '100'}
      expect(response.status).to eq 401
    end

    context 'authenticated user' do
      before do
        session['user_id'] = '1234'
        User::Auth.stub(:where).and_return([User::Auth.new(uid: '1234', is_superuser: false, active: true)])
      end
      it 'should let an authenticated user post' do
        post :post,
             {
               bogus_field: 'abc',
               type: 'CELL',
               phone: '9949919892',
               countryCode: '91',
               extension: '23',
               isPreferred: 'N'
             }
        expect(response.status).to eq 200
        json = JSON.parse(response.body)
        expect(json['statusCode']).to eq 200
        expect(json['feed']).to be
        expect(json['feed']['status']).to be
      end
    end
  end
end
