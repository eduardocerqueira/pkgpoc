# -*- coding: utf-8 -*-

from setuptools import setup, find_packages
from pkgpoc import get_version

PACKAGE_NAME = 'pkgpoc'
PACKAGE_VER = get_version()
PACKAGE_DESC = 'pkgpoc - pkgpoc python script with RPM build'
PACKAGE_URL = 'https://github.com/eduardocerqueira/pkgpoc.git'


def get_install_requires():
    requires = []
    links = []
    for line in open('requirements/production.txt', 'r'):
        line = line.strip()
        if not line.startswith('#'):
            parts = line.split('#egg=')
            if len(parts) == 2:
                links.append(line)
                requires.append(parts[1])
            else:
                requires.append(line)
    return requires, links


install_requires, dependency_links = get_install_requires()


setup(
    name=PACKAGE_NAME,
    version=PACKAGE_VER,
    description=PACKAGE_DESC,
    url=PACKAGE_URL,
    author='Eduardo Cerqueira',
    author_email='eduardomcerqueira@gmail.com',
    platforms='Fedora >= 24',
    license='GPL',
    test_suite="nose.collector",
    tests_require="nose",
    packages=find_packages(),
    include_package_data=True,
    install_requires=install_requires,
    dependency_links=dependency_links,
    entry_points={'console_scripts': ['pkgpoc=pkgpoc.driver:main']}
)
