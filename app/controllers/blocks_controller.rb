class BlocksController < ApplicationController

  rescue_from ::ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ::ActionController::ParameterMissing, with: :params_required

  before_action :set_block, only: [:show, :destroy]

  def show
    render json: {block: @block}
  end

  def index
    render json: {blocks: Block.all}
  end

  def create
    new_block = Block.new(block_params)
    if new_block.save
      render json: {block: new_block, message: "CPF '#{new_block.cpf}' bloqueado"}
    else
      render json: {error: new_block.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def destroy
    if @block.destroy
      render json: {block: @block, message: "CPF '#{@block.cpf}' removido da black list"}
    else
      render json: {error: new_block.errors.full_messages}, status: :unprocessable_entity
    end
  end

  private
    
    def set_block
      @block = Block.find(params[:id])
    end

    def block_params
      params.require(:block).permit(:cpf)
    end

    # Tratamento de erro quando registro não for encontrado
    def record_not_found
      render json: {error: "Block '#{params['id']}' não encontrado"}, status: :not_found
    end

    # Tratamento de erro quando parâmetro required não for informado
    def params_required
      render json: {error: "Parametro obrigatório não informado"}, status: 400
    end

end
