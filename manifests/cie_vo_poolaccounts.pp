
define vosupport::cie_vo_poolaccounts (
#class vosupport::cie_vo_poolaccounts (

#    $voname = $vosupport::enable_vo::voname

     $voname = undef,
) 
{
#   include grid_pool_accounts{ $voname: }
    grid_pool_accounts{$voname: 
       users_conf => '/puppet_prod/files/grid/users.conf',
    }

#   grid_pool_accounts { $voname }
}

#   class { 'grid_pool_accounts':
#      voname => $voname,
#   }
