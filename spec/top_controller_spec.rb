require 'rails_helper'

RSpec.describe TopController, :type => :controller do
  describe '#check' do

    # 異常系
    it 'カード数が足りない' do
      post :check, { cards: 'C7 C6 C5 C4'}
      expect(response).to be_success
      expect(response.status).to eq 200
      expect(controller.instance_variable_get("@message")).to eq("カードのソートと数字を半角スペース区切りで5枚分入力してください")
    end

    it 'スート以外のアルファベット' do
      post :check, { cards: 'B7 C6 C5 C4 D3'}
      expect(response).to be_success
      expect(response.status).to eq 200
      expect(controller.instance_variable_get("@message")).to eq("カードのソートと数字を半角スペース区切りで5枚分入力してください")
    end

    it 'スペース区切りがない' do
      post :check, { cards: 'C7C6 C5 C4 D4'}
      expect(response).to be_success
      expect(response.status).to eq 200
      expect(controller.instance_variable_get("@message")).to eq("カードのソートと数字を半角スペース区切りで5枚分入力してください")
    end

    it '大文字' do
      post :check, { cards: 'C7 C6 C5 C4 D４'}
      expect(response).to be_success
      expect(response.status).to eq 200
      expect(controller.instance_variable_get("@message")).to eq("カードのソートと数字を半角スペース区切りで5枚分入力してください")
    end

    it '重複' do
      post :check, { cards: 'C7 C6 C5 C4 C7'}
      expect(response).to be_success
      expect(response.status).to eq 200
      expect(controller.instance_variable_get("@message")).to eq("カードが重複しています")
    end

    # 正常系
    it 'ストレートフラッシュ判定' do
      post :check, { cards: 'C7 C6 C5 C4 C3'}
      expect(response).to be_success
      expect(response.status).to eq 200
      expect(controller.instance_variable_get("@hand")).to eq 'ストレートフラッシュ'
    end

    it 'フラッシュ判定' do
      post :check, { cards: 'H1 H12 H10 H5 H3'}
      expect(response).to be_success
      expect(response.status).to eq 200
      expect(controller.instance_variable_get("@hand")).to eq 'フラッシュ'
    end

    it 'ストレート判定' do
      post :check, { cards: 'S8 S7 H6 H5 S4'}
      expect(response).to be_success
      expect(response.status).to eq 200
      expect(controller.instance_variable_get("@hand")).to eq 'ストレート'
    end

    it 'フォー・オブ・ア・カインド判定' do
      post :check, { cards: 'D5 D6 H6 S6 C6'}
      expect(response).to be_success
      expect(response.status).to eq 200
      expect(controller.instance_variable_get("@hand")).to eq 'フォー・オブ・ア・カインド'
    end

    it 'フルハウス判定' do
      post :check, { cards: 'H9 C9 S9 H1 C1'}
      expect(response).to be_success
      expect(response.status).to eq 200
      expect(controller.instance_variable_get("@hand")).to eq 'フルハウス'
    end

    it 'スリー・オブ・ア・カインド判定' do
      post :check, { cards: 'S12 C12 D12 S5 C3'}
      expect(response).to be_success
      expect(response.status).to eq 200
      expect(controller.instance_variable_get("@hand")).to eq 'スリー・オブ・ア・カインド'
    end

    it 'ツーペア判定' do
      post :check, { cards: 'H13 D13 C2 D2 H11'}
      expect(response).to be_success
      expect(response.status).to eq 200
      expect(controller.instance_variable_get("@hand")).to eq 'ツーペア'
    end

    it 'ワンペア判定' do
      post :check, { cards: 'C10 S10 S6 H4 H2'}
      expect(response).to be_success
      expect(response.status).to eq 200
      expect(controller.instance_variable_get("@hand")).to eq 'ワンペア'
    end

    it 'ハイカード判定' do
      post :check, { cards: 'D1 D10 S9 C5 C4'}
      expect(response).to be_success
      expect(response.status).to eq 200
      expect(controller.instance_variable_get("@hand")).to eq 'ハイカード'
    end
  end
end
