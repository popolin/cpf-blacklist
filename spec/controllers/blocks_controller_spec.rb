require "rails_helper"

FREE_CPF = '56432350050'
STRING_CPF = 'FFFF.FFF'
INVALID_CPF = "11111111111"

RSpec.describe BlocksController, :type => :controller do

  before(:all) do
    Block.where(cpf: FREE_CPF).destroy_all
  end

  describe "Bloqueando CPF" do
    it "deve bloquear CPF '#{FREE_CPF}'" do
      block_params = {block: {cpf: FREE_CPF}}
      expect { post :create, params: block_params }.to change(Block, :count).by(1) 
    end
  
    it "deve prevenir duplicação de CPF já bloqueado" do
      blocked = Block.create!(cpf: FREE_CPF)
      block_params = {block: {cpf: FREE_CPF}}
      post :create, params: block_params

      json = response_body

      expect(response.code == "422")
      expect(json["error"]).to match_array ["Cpf já está na black list"]
    end

    it "deve barrar CPF não informado" do
      block_params = {}
      post :create, params: block_params
      json = response_body
      expect(response.code == "400")
      expect(json["error"]).to eq "Parametro obrigatório não informado"
    end

    it "deve barrar CPF alfanumérico" do
      block_params = {block: {cpf: STRING_CPF}}
      post :create, params: block_params

      json = response_body

      expect(response.code == "422")
      expect(json["error"]).to include "Cpf '#{STRING_CPF}' inválido"
    end

    it "deve barrar CPF inválido" do
      block_params = {block: {cpf: INVALID_CPF}}
      post :create, params: block_params

      json = response_body

      expect(response.code == "422")
      expect(json["error"]).to include "Cpf '#{INVALID_CPF}' inválido"
    end

  end

  describe "Desbloqueando CPF" do
    it "sucesso" do
      blocked = Block.create!(cpf: FREE_CPF)
      delete :destroy, params: {id: blocked.id}

      expect(response.code == "200")
    end

    it "informando ID inválido" do
      ID_INVALIDO = 0
      delete :destroy, params: {id: ID_INVALIDO}

      json = response_body
      expect(response.code == "404")
      expect(json["error"]).to eq "Block '#{ID_INVALIDO}' não encontrado"
    end
  end

  def response_body
    JSON.parse(response.body)
  end

end
