require 'spec_helper'

describe CampusSolutions::EthnicityPost do

  context 'post' do
    let(:params) { {} }
    let(:proxy) { CampusSolutions::EthnicityPost.new(fake: true, user_id: random_id, params: params) }

    context 'filtering out fields not on the whitelist' do
      let(:params) { {
        bogus: 1,
        invalid: 2,
        regRegion: 'USA'
      } }
      subject { proxy.filter_updateable_params(params) }
      it 'should strip out invalid fields' do
        expect(subject.keys.length).to eq 10
        expect(subject[:bogus]).to be_nil
        expect(subject[:invalid]).to be_nil
        expect(subject[:regRegion]).to eq 'USA'
      end
    end

    context 'converting params to Campus Solutions field names' do
      let(:params) { {
        regRegion: 'USA'
      } }
      subject {
        result = proxy.construct_cs_post(params)
        MultiXml.parse(result)['UC_CC_ETH_RQT']
      }
      it 'should convert the CalCentral params to Campus Solutions params without exploding on bogus fields' do
        expect(subject['REG_REGION']).to eq 'USA'
      end
    end

    context 'performing a post' do
      let(:params) { {
        regRegion: 'USA'
      } }
      subject {
        proxy.get
      }
      it_should_behave_like 'a simple proxy that returns errors'
      it_behaves_like 'a proxy that properly observes the profile feature flag'
      it 'should make a successful post' do
        expect(subject[:statusCode]).to eq 200
        expect(subject[:feed][:status]).to be
      end
    end
  end

  context 'with a real external service', testext: true do
    let(:proxy) { CampusSolutions::EthnicityPost.new(fake: false, user_id: random_id, params: params) }
    subject { proxy.get }

    context 'a successful post' do
      let(:params) { {
        regRegion: 'USA',
        ethnicGroupCode: 'ASIANIND',
        isPrimary: 'N',
        isHispanicLatino: 'ab',
        isAmiAln: 'N',
        isAsian: 'N',
        isBlackAfAm: 'N',
        isHawPac: 'N',
        isWhite: 'Y',
        isEthnicityValidated: 'N'
      } }
      context 'performing a real post' do
        it 'should make a successful REAL post' do
          expect(subject[:statusCode]).to eq 200
          expect(subject[:feed][:status]).to be
        end
      end
    end

    context 'an invalid post' do
      let(:params) { {
        regRegion: 'USA'
      } }
      context 'performing a real but invalid post' do
        it_should_behave_like 'a simple proxy that returns errors'
        it_should_behave_like 'a proxy that responds to user error gracefully'
      end
    end
  end
end
