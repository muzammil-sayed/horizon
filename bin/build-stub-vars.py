#!/usr/bin/env python

import sys
import os

try:
    from horizon import horizon
except ImportError:
    sys.path.append(os.path.abspath(
        os.path.join(os.path.dirname(__file__), os.pardir)))
    from horizon import horizon


if __name__ == "__main__":

    environment = 'base_template'
    component = 'base_template'
    tfvars_path = 'env/stub/terraform.tfvars'
    region = 'us-west-2'
    defaults_dir = 'defaults/base_template'
    infra_vpc = 'base_template'
    tfstate_file_path = 'env/stub/global/terraform.tfstate'
    global_vars_dest = 'env/stub'
    # TODO: stub out terraform.tfstate, with the info we need here
    infra_path = 'env/stub/infra_vpc'
    app_path = 'env/stub'

    if not os.path.exists('env/stub'):
        os.makedirs('env/stub')

    horizon.create_tfvars(environment, component, tfvars_path, region,
                          defaults_dir, infra_vpc)
    horizon.create_global_vars(tfstate_file_path, global_vars_dest,
                               defaults_dir)
    horizon.create_app_vars(infra_path, app_path, defaults_dir)
