require 'rails_helper'

RSpec.describe Cards, :type => :request do

  # 異常系
  it 'カード数が足りない' do
    post '/api/cards/check', { cards: ['C7 C6 C5 C4']}
    json = JSON.parse(response.body)
    expect(response).to be_success
    expect(response.status).to eq 201
    expect(json["error"][0]["error"]).to eq 'カードのソートと数字を半角スペース区切りで5枚分入力してください'
  end

  it 'スート以外のアルファベット' do
    post '/api/cards/check', { cards: ['B7 C6 C5 C4 D3']}
    json = JSON.parse(response.body)
    expect(response).to be_success
    expect(response.status).to eq 201
    expect(json["error"][0]["error"]).to eq 'カードのソートと数字を半角スペース区切りで5枚分入力してください'
  end

  it 'スペース区切りがない' do
    post '/api/cards/check', { cards: ['C7C6 C5 C4 D4']}
    json = JSON.parse(response.body)
    expect(response).to be_success
    expect(response.status).to eq 201
    expect(json["error"][0]["error"]).to eq 'カードのソートと数字を半角スペース区切りで5枚分入力してください'
  end

  it '大文字' do
    post '/api/cards/check', { cards: ['C7 C6 C5 C4 D４']}
    json = JSON.parse(response.body)
    expect(response).to be_success
    expect(response.status).to eq 201
    expect(json["error"][0]["error"]).to eq 'カードのソートと数字を半角スペース区切りで5枚分入力してください'
  end

  it '重複' do
    post '/api/cards/check', { cards: ['C7 C6 C4 C4 C4']}
    json = JSON.parse(response.body)
    expect(response).to be_success
    expect(response.status).to eq 201
    expect(json["error"][0]["error"]).to eq 'カードが重複しています'
  end

  # 正常系
  it 'ストレートフラッシュ判定' do
    post '/api/cards/check', { cards: ['C7 C6 C5 C4 C3']}
    json = JSON.parse(response.body)
    expect(response).to be_success
    expect(response.status).to eq 201
    expect(json["result"][0]["hand"]).to eq 'ストレートフラッシュ'
    expect(json["result"][0]["strength"]).to eq 9
  end

  it 'フラッシュ判定' do
    post '/api/cards/check', { cards: ['H1 H12 H10 H5 H3']}
    json = JSON.parse(response.body)
    expect(response).to be_success
    expect(response.status).to eq 201
    expect(json["result"][0]["hand"]).to eq 'フラッシュ'
    expect(json["result"][0]["strength"]).to eq 6
  end

  it 'ストレート判定' do
    post '/api/cards/check', { cards: ['S8 S7 H6 H5 S4']}
    json = JSON.parse(response.body)
    expect(response).to be_success
    expect(response.status).to eq 201
    expect(json["result"][0]["hand"]).to eq 'ストレート'
    expect(json["result"][0]["strength"]).to eq 5
  end

  it 'フォー・オブ・ア・カインド判定' do
    post '/api/cards/check', { cards: ['D5 D6 H6 S6 C6']}
    json = JSON.parse(response.body)
    expect(response).to be_success
    expect(response.status).to eq 201
    expect(json["result"][0]["hand"]).to eq 'フォー・オブ・ア・カインド'
    expect(json["result"][0]["strength"]).to eq 8
  end

  it 'フルハウス判定' do
    post '/api/cards/check', { cards: ['H9 C9 S9 H1 C1']}
    json = JSON.parse(response.body)
    expect(response).to be_success
    expect(response.status).to eq 201
    expect(json["result"][0]["hand"]).to eq 'フルハウス'
    expect(json["result"][0]["strength"]).to eq 7
  end

  it 'スリー・オブ・ア・カインド判定' do
    post '/api/cards/check', { cards: ['S12 C12 D12 S5 C3']}
    json = JSON.parse(response.body)
    expect(response).to be_success
    expect(response.status).to eq 201
    expect(json["result"][0]["hand"]).to eq 'スリー・オブ・ア・カインド'
    expect(json["result"][0]["strength"]).to eq 4
  end

  it 'ツーペア判定' do
    post '/api/cards/check', { cards: ['H13 D13 C2 D2 H11']}
    json = JSON.parse(response.body)
    expect(response).to be_success
    expect(response.status).to eq 201
    expect(json["result"][0]["hand"]).to eq 'ツーペア'
    expect(json["result"][0]["strength"]).to eq 3
  end

  it 'ワンペア判定' do
    post '/api/cards/check', { cards: ['C10 S10 S6 H4 H2']}
    json = JSON.parse(response.body)
    expect(response).to be_success
    expect(response.status).to eq 201
    expect(json["result"][0]["hand"]).to eq 'ワンペア'
    expect(json["result"][0]["strength"]).to eq 2
  end

  it 'ハイカード判定' do
    post '/api/cards/check', { cards: ['D1 D10 S9 C5 C4']}
    json = JSON.parse(response.body)
    expect(response).to be_success
    expect(response.status).to eq 201
    expect(json["result"][0]["hand"]).to eq 'ハイカード'
    expect(json["result"][0]["strength"]).to eq 1
  end
end