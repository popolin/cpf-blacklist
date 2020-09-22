require 'rails_helper'

RSpec.describe Block, type: :model do
  
  valid_block = Block.new(cpf: '64738948024')

  describe "Validations" do

    it "CPF válido" do
      expect(valid_block).to be_valid
    end

    it "já bloqueado" do
      Block.create(cpf: valid_block.cpf)
      expect(valid_block).to_not be_valid
    end

    it "formato inválido" do
      valid_block.cpf = "123123"
      expect(valid_block).to_not be_valid
    end

  end

end
