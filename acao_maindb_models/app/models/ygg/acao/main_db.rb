module Ygg
module Acao
module MainDb

class LastUpdate < ActiveRecord::Base
  self.table_name = 'maindb_last_update'
end

module LastUpdateTracker
  def last_update
    # USE master;
    # GO
    # GRANT VIEW SERVER STATE TO lino;

    connection.exec_query("SELECT OBJECT_NAME(OBJECT_ID) AS DatabaseName, last_user_update,* " +
                            "FROM sys.dm_db_index_usage_stats WHERE database_id = DB_ID('acao_pro') " +
                            "AND OBJECT_ID=OBJECT_ID('#{table_name}')")[0]['last_user_update']
  end

  def get_lu
    Ygg::Acao::MainDb::LastUpdate.find_or_create_by!(tablename: table_name.to_s)
  end

  def has_been_updated?
    lu = get_lu
    lu.last_update != last_update
  end

  def update_last_update!
    lu = get_lu
    lu.last_update = last_update
    lu.save!
  end
end

end
end
end
