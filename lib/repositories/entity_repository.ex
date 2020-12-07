defmodule Repository.EntityRepository do 
  @collection "entities"

  def add(data), do: :database |> Mongo.insert_one(@collection, data) 
  
  def get(id), do: :database |>  Mongo.find_one(@collection, %{"_id" => id}) 
  
end
