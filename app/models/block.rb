class Block < ApplicationRecord

  SITUACAO = {
    :free => 'FREE',
    :block => 'BLOCK'
  }

  validates :cpf, presence: { message: "obrigatório" }
  validates :cpf, format: { with: /\A\d+\z/, message: "deve ser númerico" }
  validates_length_of :cpf, :is => 11, :message => "inválido"
  validates :cpf, uniqueness: { message: "já está na black list" }
  validates :cpf, :cpf => true


  def self.find_by_cpf(cpf)
    Block.where(cpf: cpf).first
  end

end