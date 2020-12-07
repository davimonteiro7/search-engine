defmodule Services.IndexService do 
  alias Repository.IndexRepository
  require Logger
  @common_words ["this", "has", "to", "or"] 
  
  def init(data, inserted) do
    object_id = inserted |> elem(1) |> Map.get(:inserted_id)
    indexes = create_index(data, object_id)
    find_and_update_index(indexes)
  end 

  def get_references(query) do
    indexes = IndexRepository.get_indexes(String.downcase(query))
    indexes 
    |> Enum.map(fn (%{"_id" => id} = r) -> %{ r | "_id" => id} end)
    |> Enum.map(fn index -> Map.get(index, "entities") |> List.first() end)
    |> Enum.uniq
  
  end
  
  defp add_index(index) do
    IndexRepository.add(index)
    {:ok, "added new index"}
  end

  defp find_and_update_index(indexes) do
    Enum.each(indexes, fn index ->
      case index |> Map.get("word") |> IndexRepository.get do
        nil -> add_index(index)
        old_index -> update_index(old_index, index)
      end
    end) 
  end
  
  defp update_index(old_index, index) do
    entity_reference = Enum.concat(old_index |> Map.get("entities") , index |> Map.get("entities"))
    object_id = old_index |> Map.get("_id")
    data =  index 
            |> Map.get_and_update("entities",fn entities -> {entities, entity_reference} end)
            |> elem(1)
    IndexRepository.update(object_id, data)
    
  end

  defp create_index(data, object_id) do 
    Map.fetch(data, "title") |> elem(1)
      |> String.split()
      |> Enum.filter(fn word -> word in @common_words == false end)
      |> Enum.map(fn index -> %{"word" => String.downcase(index), "entities" => [object_id]} end)
    
  end
end
