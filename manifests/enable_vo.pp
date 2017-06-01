#enables vosupport features (accounts, mappings, environment)
define vosupport::enable_vo (
  $voname=$name,
  $enable_poolaccounts = true,
  $enable_mappings_for_service = undef,
  $enable_mkgridmap_for_service = undef,
  $enable_environment = true,
  $enable_voms = true,
  $enable_gridmapdir = false,
  $enable_sudoers = false,
  $enable_sandboxdir = false,
)
{    
    if ($enable_voms) {
      #lookup table for VO names in voms module, when the name of the voms module is different from the VO name
      $voms_module_name= $voname? {
         'vo.aleph.cern.ch' => 'aleph',
         'vo.cta.in2p3.fr' => 'vo_cta_in2p3_fr',
        default => $voname
      }
      include "voms::${voms_module_name}"      
    }
    
    if ($enable_poolaccounts) {
#      include vosupport::vo_poolaccounts      
#      Setuphome <| voname == $voname |>

#       include vosupport::cie_vo_poolaccounts{ $voname: }

        vosupport::cie_vo_poolaccounts{$voname: 
            voname => $voname,
        }

#        class { 'vosupport::cie_vo_poolaccounts':
#          voname => $voname,
#        }

    }
    
    if ($enable_environment) {
      include vosupport::vo_environment
      Voenv  <| voname == $voname |>
    }
    
    if $enable_mappings_for_service != undef {
#      include vosupport::vo_mappings
      include vosupport::cie_vo_mappings
      
#      #create file fragments for the specified VO and service
#      $vomappingdata = hiera_hash('vosupport::mappings',undef)
#      
#      concat::fragment{"${voname}_mapfile": 
#	target  => "/etc/grid-security/grid-mapfile",
#	order   => "9",
#	content => template('vosupport/gridmapfile.erb'),
#      }
#      
#      concat::fragment{"${voname}_vomsmapfile": 
#        target  => "/etc/grid-security/voms-grid-mapfile",
#        order   => "9",
#        content => template('vosupport/gridmapfile.erb')
#      }
#      
#      concat::fragment{"${voname}_groupmapfile": 
#	target  => "/etc/grid-security/groupmapfile",
#	order   => "9",
#	content => template('vosupport/groupmapfile.erb')
#	
    }
    
    if $enable_mkgridmap_for_service != undef {
        include vosupport::vo_lcgdm_mappings
        
        vosupport::enable_lcgdm_vo{$voname:
            voname=>$voname,
            unprivilegedmkgridmap=>false,
            gridservice=>$enable_mkgridmap_for_service
        }
    }
    
    if $enable_gridmapdir {
      include vosupport::vo_gridmapdir
      Setupgridmapdir <| voname == $voname |>
    }
    
    if $enable_sudoers {
      include vosupport::vo_sudoers
      Setupsudoers <| voname == $voname |>
    }
    
    if $enable_sandboxdir {
      include vosupport::vo_sandboxdir
      Setupsandbox  <| voname == $voname |>
    }
}


