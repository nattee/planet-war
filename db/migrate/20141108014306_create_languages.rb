class CreateLanguages < ActiveRecord::Migration
  def change
    create_table :languages do |t|
      t.string :name
      t.string :pretty_name
      t.string :ext
      t.string :common_ext

      t.timestamps
    end

    Language.create name: "cpp" , pretty_name: "C++"  , ext: "cpp"  , common_ext: "cpp,cc"
    Language.create name: "java", pretty_name: "Java" , ext: "java" , common_ext: "java"
  end
end
