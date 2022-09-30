#!/usr/bin/python3
"""Script that distributes an archive to web_servers, using do_deploy
"""
from fabric.api import local, env, run, put, sudo
from fabric import operations

env.hosts = ['44.210.150.159', '35.173.47.15']


def do_deploy(archive_path):
    """Function that deploys archive to web_servers"""
    if archive_path:
        archive_file = archive_path.split("/")[1]
        archive_dir = archive_file.split(".")[0]
        releases = '/data/web_static/releases/'
        current = '/data/web_static/current'

        try:
            # upload the archive to /tmp/
            put(archive_path, '/tmp/')
            # make dir /data/web_static/releases/archive_filename_bar_ext
            # and uncompress the archive
            run('mkdir -p {}{}'.format(releases, archive_dir))
            run('tar -xzf /tmp/{} -C {}{}'.format(
                archive_file, releases, archive_dir))
            # delete the archive from web_server
            run('rm /tmp/{}'.format(archive_file))

            run('mv {}{}/web_static/* {}{}'.format(
                releases, archive_dir, releases, archive_dir))
            run('rm -rf {}{}/web_static'.format(releases, archive_dir))
            # delete the old symoblic link
            run('rm -rf {}'.format(current))
            # create the new symbolic link
            run('ln -s {}{} {}'.format(releases, archive_dir, current))

            return True
        except:
            return False

    else:
        return False
