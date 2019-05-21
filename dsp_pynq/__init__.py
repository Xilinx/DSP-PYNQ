import os
import shutil
from distutils.dir_util import copy_tree

def install_notebooks(notebook_dir=None):
    """Copy notebooks to the filesystem
    notebook_dir: str
        An optional destination filepath. If None, assume PYNQ's default
        jupyter_notebooks folder.
    """
    if notebook_dir == None:
        notebook_dir = os.environ['PYNQ_JUPYTER_NOTEBOOKS']
        if not os.path.isdir(notebook_dir):
            raise ValueError(
            f'Directory {notebook_dir} does not exist. Please supply a `notebook_dir` argument.')

    src_nb_dir = os.path.join(os.path.dirname(__file__), 'notebooks')
    src_bs_dir = os.path.join(os.path.dirname(__file__), 'bitstreams')
    dst_nb_dir = os.path.join(notebook_dir, 'dsp_pynq')
    dst_bs_dir = os.path.join(dst_nb_dir, 'assets')
    if os.path.exists(dst_nb_dir):
        shutil.rmtree(dst_nb_dir)
    copy_tree(src_nb_dir, dst_nb_dir)
    copy_tree(src_bs_dir, dst_bs_dir)
