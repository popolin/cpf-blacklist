class CpfValidator < ActiveModel::Validator
  def validate(record)
    return true if CPF.valid?(record.cpf, strict: true)
    record.errors[options[:field_name] || :cpf] << "'#{record.cpf}' inválido"
  end
end
