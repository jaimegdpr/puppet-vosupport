#initialize VO mapping resources
class vosupport::cie_vo_mappings()
{

  file{'/etc/grid-security/grid-mapfile':
    ensure => present,
    owner =>  'root',
    group =>  'root',
    mode  =>  '0644',
    source => 'puppet:///modules/vosupport/grid-mapfile'
  }

  file{'/etc/grid-security/voms-grid-mapfile':
    ensure => present,
    owner =>  'root',
    group =>  'root',
    mode  =>  '0644',
    source => 'puppet:///modules/vosupport/voms-grid-mapfile'
  }
  
  file{'/etc/grid-security/groupmapfile':
    ensure => present,
    owner =>  'root',
    group =>  'root',
    mode  =>  '0644',
    source => 'puppet:///modules/vosupport/groupmapfile'
  }

}
