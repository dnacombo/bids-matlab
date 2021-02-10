function test_suite = test_append_to_layout %#ok<*STOUT>
  try % assignment of 'localfunctions' is necessary in Matlab >= 2016
    test_functions = localfunctions(); %#ok<*NASGU>
  catch % no problem; early Matlab versions can use initTestSuite fine
  end
  initTestSuite;
end

function test_append_to_layout_basic()

  schema = bids.schema.load_schema();

  subject = struct('anat', struct([]));

  modality = 'anat';

  file = '../sub-16/anat/sub-16_ses-mri_run-1_acq-hd_T1w.nii.gz';
  subject = bids.internal.append_to_layout(file, subject, modality, schema);

  expected.anat = struct( ...
                         'filename', 'sub-16_ses-mri_run-1_acq-hd_T1w.nii.gz', ...
                         'suffix', 'T1w', ...
                         'ext', '.nii.gz', ...
                         'entities', struct('sub', '16', ...
                                            'ses', 'mri', ...
                                            'run', '1', ...
                                            'acq', 'hd', ...
                                            'ce', '', ...
                                            'rec', '', ...
                                            'part', ''));

  assertEqual(subject.anat, expected.anat);

end

function test_append_to_structure_basic_test()

  schema = bids.schema.load_schema();

  subject = struct('anat', struct([]));
  modality = 'anat';

  file = '../sub-16/anat/sub-16_ses-mri_run-1_acq-hd_T1w.nii.gz';
  subject = bids.internal.append_to_layout(file, subject, modality, schema);

  file = '../sub-16/anat/sub-16_ses-mri_run-1_T1map.nii.gz';
  subject = bids.internal.append_to_layout(file, subject, modality, schema);

  expected(1).anat = struct( ...
                            'filename', 'sub-16_ses-mri_run-1_acq-hd_T1w.nii.gz', ...
                            'suffix', 'T1w', ...
                            'ext', '.nii.gz', ...
                            'entities', struct('sub', '16', ...
                                               'ses', 'mri', ...
                                               'run', '1', ...
                                               'acq', 'hd', ...
                                               'ce', '', ...
                                               'rec', '', ...
                                               'part', ''));

  expected(2).anat = struct( ...
                            'filename', 'sub-16_ses-mri_run-1_T1map.nii.gz', ...
                            'suffix', 'T1map', ...
                            'ext', '.nii.gz', ...
                            'entities', struct('sub', '16', ...
                                               'ses', 'mri', ...
                                               'run', '1', ...
                                               'acq', '', ...
                                               'ce', '', ...
                                               'rec', '', ...
                                               'part', ''));     %#ok<*STRNU>

end

function test_append_to_layout_schemaless()

  subject = struct('newmod', struct([]));

  modality = 'newmod';

  file = '../sub-16/newmod/sub-16_schema-less_anything-goes_newsuffix.EXT';
  subject = bids.internal.append_to_layout(file, subject, modality);

  expected.newmod = struct( ...
                           'filename', 'sub-16_schema-less_anything-goes_newsuffix.EXT', ...
                           'suffix', 'newsuffix', ...
                           'ext', '.EXT', ...
                           'entities', struct('sub', '16', ...
                                              'schema', 'less', ...
                                              'anything', 'goes'));

  assertEqual(subject.newmod, expected.newmod);

end
