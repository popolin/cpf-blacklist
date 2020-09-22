class HomeController < ApplicationController

  def index
  end

  def consulta
    push_call
    
    if params['cpf'].nil?
      render json: {error: "CPF não informado"}, status: :not_found
    elsif !CPF.valid?(params['cpf'], strict: true)
      render json: {error: "CPF '#{params['cpf']}' inválido"}, status: :unprocessable_entity
    else
      numeric_cpf = params['cpf'].delete("^0-9")
      black_list = Block.find_by_cpf(numeric_cpf)
      if black_list.nil?
        situação = Block::SITUACAO[:free]
      else
        situação = Block::SITUACAO[:block]
        block_id = black_list.id
      end
      render json: {situacao: situação, block_id: block_id, numeric_cpf: numeric_cpf, cpf: params['cpf']}, status: :ok
    end
  end

  # Guardo em ambiente a data de inicialização. 
  # ConsultaRegistry encapsula variável global para contagem
  def status
    render json: {
      server_update: ENV["STARTUP_TIME"], 
      consultas: ConsultaRegistry.count, 
      blocks: Block.count}, status: :ok
  end


  private

    def push_call
      ConsultaRegistry.push
    end

  
end