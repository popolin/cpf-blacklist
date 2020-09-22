require 'rails_helper'

FREE_CPF = '64738948024'
BLOCKED_CPF = '89389845084'
BLOCKED_CPF_MASKED = '893.898.450-84'

RSpec.describe "Consulta", :type => :request do

  before(:all) do
    Block.where(cpf: FREE_CPF).destroy_all
    @block = Block.find_or_create_by(cpf: BLOCKED_CPF)
  end

  describe "CPF" do

    it "'#{FREE_CPF}': FREE" do

      get '/consulta', params: { cpf: FREE_CPF }

      json = response_body

      expect(response.code == "200")
      expect(json["situacao"]).to eq "FREE"
      expect(json["block_id"]).to be_nil

    end

    it "'#{BLOCKED_CPF}': BLOCK" do

      get '/consulta', params: { cpf: BLOCKED_CPF }

      json = response_body

      expect(response.code == "200")
      expect(json["situacao"]).to eq "BLOCK"
      expect(json["block_id"]).to eq @block.id

    end

    it "'#{BLOCKED_CPF_MASKED}': BLOCK removing mask" do

      blocked = Block.find_or_create_by(cpf: BLOCKED_CPF)
      get '/consulta', params: { cpf: BLOCKED_CPF_MASKED }

      json = response_body

      expect(response.code == "200")
      expect(json["situacao"]).to eq "BLOCK"
      expect(json["block_id"]).to eq blocked.id

    end

    it "sem informar o 'cpf'" do

      get '/consulta'

      json = response_body

      expect(response.code == "404")
      expect(json["error"]).to eq "CPF não informado"

    end

  end

  def response_body
    JSON.parse(response.body)
  end

end