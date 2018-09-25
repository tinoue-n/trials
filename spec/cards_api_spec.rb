require 'rails_helper'

RSpec.describe Cards, :type => :request do

  describe '異常系' do
    describe '単体' do
      it 'カード数が足りない' do
        post '/api/cards/check', { cards: ['C7 C6 C5 C4'] }
        json = JSON.parse(response.body)
        expect(response).to be_success
        expect(response.status).to eq 201
        expect(json["error"][0]["error"]).to eq ['カードは5枚分入力してください']
      end

      it 'スート以外のアルファベット' do
        post '/api/cards/check', { cards: ['B7 C6 C5 C4 D3'] }
        json = JSON.parse(response.body)
        expect(response).to be_success
        expect(response.status).to eq 201
        expect(json["error"][0]["error"]).to eq ['スート（DHSC）、数字、半角スペース以外の文字が含まれています']
      end

      it 'スペース区切りがない' do
        post '/api/cards/check', { cards: ['C7C6 C5 C4 D4'] }
        json = JSON.parse(response.body)
        expect(response).to be_success
        expect(response.status).to eq 201
        expect(json["error"][0]["error"]).to eq ['カードは5枚分入力してください', 'カード同士は半角スペースで区切ってください']
      end

      it '全角' do
        post '/api/cards/check', { cards: ['C7 C6 C5 C4 D４'] }
        json = JSON.parse(response.body)
        expect(response).to be_success
        expect(response.status).to eq 201
        expect(json["error"][0]["error"]).to eq ["スート（DHSC）、数字、半角スペース以外の文字が含まれています", "全角文字が含まれています"]
      end

      it '1~13以外の数字' do
        post '/api/cards/check', { cards: ['C7 C6 C5 C4 D44'] }
        json = JSON.parse(response.body)
        expect(response).to be_success
        expect(response.status).to eq 201
        expect(json["error"][0]["error"]).to eq ["カードの数字は1~13で入力してください"]
      end

      it '重複' do
        post '/api/cards/check', { cards: ['C7 C6 C4 C4 C4'] }
        json = JSON.parse(response.body)
        expect(response).to be_success
        expect(response.status).to eq 201
        expect(json["error"][0]["error"]).to eq ['カードが重複しています']
      end
    end

    describe '複数' do
      it '同一エラーが二回' do
        post '/api/cards/check', { cards: ['C7 C6 C4 C4 C4', 'C7 C6 C4 C4 C4'] }
        json = JSON.parse(response.body)
        expect(response).to be_success
        expect(response.status).to eq 201
        expect(json["error"][0]["error"]).to eq ['カードが重複しています']
        expect(json["error"][1]["error"]).to eq ['カードが重複しています']
      end
      it '二種類のエラー' do
        post '/api/cards/check', { cards: ['C7 C6 C4 C4 C4', 'C7 C6 C5 C4 D44'] }
        json = JSON.parse(response.body)
        expect(response).to be_success
        expect(response.status).to eq 201
        expect(json["error"][0]["error"]).to eq ['カードが重複しています']
        expect(json["error"][1]["error"]).to eq ['カードの数字は1~13で入力してください']
      end
      it '正常とエラー' do
        post '/api/cards/check', { cards: ['C7 C6 C5 C4 C3', 'C7 C6 C4 C4 C4'] }
        json = JSON.parse(response.body)
        expect(response).to be_success
        expect(response.status).to eq 201
        expect(json["result"][0]["hand"]).to eq 'ストレートフラッシュ'
        expect(json["error"][0]["error"]).to eq ['カードが重複しています']
      end
    end
  end

  describe '正常系' do
    describe '単体' do
      it 'ストレートフラッシュ判定' do
        post '/api/cards/check', { cards: ['C7 C6 C5 C4 C3'] }
        json = JSON.parse(response.body)
        expect(response).to be_success
        expect(response.status).to eq 201
        expect(json["result"][0]["hand"]).to eq 'ストレートフラッシュ'
      end

      it 'フラッシュ判定' do
        post '/api/cards/check', { cards: ['H1 H12 H10 H5 H3'] }
        json = JSON.parse(response.body)
        expect(response).to be_success
        expect(response.status).to eq 201
        expect(json["result"][0]["hand"]).to eq 'フラッシュ'
      end

      it 'ストレート判定' do
        post '/api/cards/check', { cards: ['S8 S7 H6 H5 S4'] }
        json = JSON.parse(response.body)
        expect(response).to be_success
        expect(response.status).to eq 201
        expect(json["result"][0]["hand"]).to eq 'ストレート'
      end

      it 'フォー・オブ・ア・カインド判定' do
        post '/api/cards/check', { cards: ['D5 D6 H6 S6 C6'] }
        json = JSON.parse(response.body)
        expect(response).to be_success
        expect(response.status).to eq 201
        expect(json["result"][0]["hand"]).to eq 'フォー・オブ・ア・カインド'
      end

      it 'フルハウス判定' do
        post '/api/cards/check', { cards: ['H9 C9 S9 H1 C1'] }
        json = JSON.parse(response.body)
        expect(response).to be_success
        expect(response.status).to eq 201
        expect(json["result"][0]["hand"]).to eq 'フルハウス'
      end

      it 'スリー・オブ・ア・カインド判定' do
        post '/api/cards/check', { cards: ['S12 C12 D12 S5 C3'] }
        json = JSON.parse(response.body)
        expect(response).to be_success
        expect(response.status).to eq 201
        expect(json["result"][0]["hand"]).to eq 'スリー・オブ・ア・カインド'
      end

      it 'ツーペア判定' do
        post '/api/cards/check', { cards: ['H13 D13 C2 D2 H11'] }
        json = JSON.parse(response.body)
        expect(response).to be_success
        expect(response.status).to eq 201
        expect(json["result"][0]["hand"]).to eq 'ツーペア'
      end

      it 'ワンペア判定' do
        post '/api/cards/check', { cards: ['C10 S10 S6 H4 H2'] }
        json = JSON.parse(response.body)
        expect(response).to be_success
        expect(response.status).to eq 201
        expect(json["result"][0]["hand"]).to eq 'ワンペア'
      end

      it 'ハイカード判定' do
        post '/api/cards/check', { cards: ['D1 D10 S9 C5 C4'] }
        json = JSON.parse(response.body)
        expect(response).to be_success
        expect(response.status).to eq 201
        expect(json["result"][0]["hand"]).to eq 'ハイカード'
      end
    end

    describe '複数役' do
      it 'ストレートフラッシュvsフラッシュ' do
        post '/api/cards/check', { cards: ['C7 C6 C5 C4 C3', 'H1 H12 H10 H5 H3'] }
        json = JSON.parse(response.body)
        expect(response).to be_success
        expect(response.status).to eq 201
        expect(json["result"][0]["hand"]).to eq 'ストレートフラッシュ'
        expect(json["result"][0]["best"]).to eq true
        expect(json["result"][1]["hand"]).to eq 'フラッシュ'
        expect(json["result"][1]["best"]).to eq false
      end

      it 'フラッシュvsスリー・オブ・ア・カインド' do
        post '/api/cards/check', { cards: ['H1 H12 H10 H5 H3', 'S12 C12 D12 S5 C3'] }
        json = JSON.parse(response.body)
        expect(response).to be_success
        expect(response.status).to eq 201
        expect(json["result"][0]["hand"]).to eq 'フラッシュ'
        expect(json["result"][0]["best"]).to eq true
        expect(json["result"][1]["hand"]).to eq 'スリー・オブ・ア・カインド'
        expect(json["result"][1]["best"]).to eq false
      end
    end
  end
end