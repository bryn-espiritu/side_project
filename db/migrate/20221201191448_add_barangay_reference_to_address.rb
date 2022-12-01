class AddBarangayReferenceToAddress < ActiveRecord::Migration[7.0]
  def change
    add_reference :addresses, :barangay
  end
end
