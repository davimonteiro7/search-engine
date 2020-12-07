defmodule Repository.IndexRepository do
  @collection "indexes"
  
  def add(data) do
    :database |> Mongo.insert_one(@collection, data) 
  end

  def get(word) do 
    :database |> Mongo.find_one(@collection, %{"word" => word})
  end

  def get_indexes(query) do 
    :database |> Mongo.find(@collection, %{"word": %{"$regex" => query}})
  end 

  def update(id, data) do
    :database |> Mongo.find_one_and_update(@collection, %{"_id" => id}, %{"$set": data})
  end
end
