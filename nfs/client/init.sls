{% set host = salt['pillar.get']('on_the_fly_tenant_fqdn', grains.get('instance_id')) %}

{% if grains['os_family'] == 'RedHat' %}

     nfs_package:
       pkg.installed:
         - name: nfs-utils

     rpcbind_service:
       cmd:
         - run
         - name: /sbin/service rpcbind restart

     nfslock_service:
       cmd:
         - run
         - name: /sbin/service nfslock restart



     {{ salt['pillar.get']('mnt_point') }}:
          mount.mounted:
              - device: {{ salt['pillar.get']('nfs_volume') }}
              - fstype: nfs
              - persist: True
              - mkmnt: True
              - opts: nfsvers=3,tcp,defaults
              - require:
                - pkg: nfs_package
                - cmd: rpcbind_service
                - cmd: nfslock_service

{% endif %}
