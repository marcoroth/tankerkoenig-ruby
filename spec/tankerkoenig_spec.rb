RSpec.describe Tankerkoenig do

  it 'has a version number' do
    expect(Tankerkoenig::VERSION).not_to be(nil)
  end

  it 'has an api_base' do
    expect(Tankerkoenig.api_base).not_to be(nil)
    expect(Tankerkoenig.api_base).not_to be('')
  end

  it 'has an api_key' do
    expect(Tankerkoenig.api_key).not_to be(nil)
    expect(Tankerkoenig.api_key).not_to be('')
  end

  it 'returns stations from Station#list' do
    lat = 52.521
    lng = 13.438
    rad = 1.5
    sort = :dist
    response = Tankerkoenig::Station.list(lat: lat, lng: lng, rad: rad, sort: sort, type: :all)
    expect(response.any?).to eq(true)
    response = Tankerkoenig::Station.list(lat: lat, lng: lng, rad: rad, sort: sort, type: :e5)
    expect(response.any?).to eq(true)
    response = Tankerkoenig::Station.list(lat: lat, lng: lng, rad: rad, sort: sort, type: :e10)
    expect(response.any?).to eq(true)
    response = Tankerkoenig::Station.list(lat: lat, lng: lng, rad: rad, sort: sort, type: :diesel)
    expect(response.any?).to eq(true)
  end

  it 'returns a station detail from Station#detail' do
    id = '24a381e3-0d72-416d-bfd8-b2f65f6e5802'
    response = Tankerkoenig::Station.detail(id)
    expect(response.success?).to eq(true)
    expect(response.status).not_to be('error')
    expect(response.message).to eq('')
    expect(response.any?).to eq(true)
    expect(response.result.id == id)
  end

  it 'returns a list of stations by ids from Price#get' do
    ids = ['4429a7d9-fb2d-4c29-8cfe-2ca90323f9f8', '446bdcf5-9f75-47fc-9cfa-2c3d6fda1c3b', '60c0eefa-d2a8-4f5c-82cc-b5244ecae955', '44444444-4444-4444-4444-444444444444']
    response = Tankerkoenig::Price.get(ids)
    expect(response.success?).to eq(true)
    expect(response.status).not_to be('error')
    expect(response.message).to eq('')
    expect(response.any?).to eq(true)
    expect(response.result.first.station_id == ids.first)
  end

  it 'returns errors from Station#list' do
    response = Tankerkoenig::Station.list(lat: nil, lng: nil, rad: nil, sort: nil, type: :all)
    expect(response.any?).to eq(false)
    expect(response.message).to eq('you need to submit a valid lat coordinate')

    response = Tankerkoenig::Station.list(lat: 52.521, lng: nil, rad: nil, sort: nil, type: :all)
    expect(response.any?).to eq(false)
    expect(response.message).to eq('you need to submit a valid lng coordinate')

    response = Tankerkoenig::Station.list(lat: 52.521, lng: 13.438, rad: nil, sort: nil, type: :all)
    expect(response.any?).to eq(false)
    expect(response.message).to eq('you need to submit a valid radius between 1 and 25')

    response = Tankerkoenig::Station.list(lat: 52.521, lng: 13.438, rad: 1.5, sort: nil, type: :all)
    expect(response.any?).to eq(false)
    expect(response.message).to eq('wrong sort parameter. The available options are ["price", "dist"]')

    response = Tankerkoenig::Station.list(lat: 52.521, lng: 13.438, rad: 1.5, sort: :dist, type: :abc)
    expect(response.any?).to eq(false)
    expect(response.message).to eq('wrong type parameter. The available options are ["e5", "e10", "diesel", "all"]')
  end

  it 'returns an error from Station#detail' do
    response = Tankerkoenig::Station.detail(nil)
    expect(response.any?).to eq(false)
    expect(response.message).to eq('you have to submit a valid station id')
  end

  it 'returns an error from Price#get' do
    response = Tankerkoenig::Price.get(nil)
    expect(response.any?).to eq(false)
    expect(response.message).to eq('ids must be an Array or a String')
  end

end
