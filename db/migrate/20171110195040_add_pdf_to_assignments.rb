class AddPdfToAssignments < ActiveRecord::Migration[5.1]
  def change
    add_attachment :assignments, :pdf_instruction
  end
end
