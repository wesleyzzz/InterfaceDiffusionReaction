[Mesh]
  type = GeneratedMesh
  dim = 1
  nx = 10
  xmax = 2
[]

[MeshModifiers]
  [subdomain1]
    type = SubdomainBoundingBox
    bottom_left = '1.0 0 0'
    block_id = 1
    top_right = '2.0 1.0 0'
  []
  [interface]
    type = SideSetsBetweenSubdomains
    depends_on = 'subdomain1'
    master_block = '0'
    paired_block = '1'
    new_boundary = 'master0_interface'
  []
[]

[Variables]
  [u]
    order = FIRST
    family = LAGRANGE
    block = '0'
  []
  [v]
    order = FIRST
    family = LAGRANGE
    block = '1'
  []
[]

[Kernels]
  [diff_u]
    type = MatDiffusion
    variable = u
    block = '0'
  []
  [diff_v]
    type = MatDiffusion
    variable = v
    block = '1'
  []
[]

[InterfaceKernels]
  [interface]
    type = InterfaceDiffusion
    variable = u
    neighbor_var = 'v'
    boundary = 'master0_interface'
    D = D
    D_neighbor = D
  []
  [interface_reaction]
    type = InterfaceReaction
    variable = u
    neighbor_var = 'v'
    boundary = 'master0_interface'
    D = D
    D_neighbor = D
    kf = 1 # Forward reaction rate coefficient
    kb = 2 # Backward reaction rate coefficient
  []
[]

[BCs]
  [left]
    type = DirichletBC
    variable = u
    boundary = 'left'
    value = 1
  []
  [right]
    type = DirichletBC
    variable = v
    boundary = 'right'
    value = 0
  []
[]

[Materials]
  [stateful]
    type = StatefulMaterial
    initial_diffusivity = 1
    boundary = 'master0_interface'
  []
  [block0]
    type = GenericConstantMaterial
    block = '0'
    prop_names = 'D'
    prop_values = '4'
  []
  [block1]
    type = GenericConstantMaterial
    block = '1'
    prop_names = 'D'
    prop_values = '2'
  []

  [Diffusivity_of_Ce_in_Liquid]
    # Arrhenius equation,Use the relationship of Ce in liquid Cs, D=exp(-8.765-0.144/(T*k))
    # function = 'exp(-8.765-0.144/k/T)'
    type = ParsedMaterial
    f_name = D_l
    args = 'T'
    constant_names = 'k'
    constant_expressions = '8.61733e-5'
    function = 2
    block = '1'
  []

[]

[Preconditioning]
  [smp]
    type = SMP
    full = true
  []
[]

[Executioner]
  type = Steady
  solve_type = PJFNK
[]

[Outputs]
  exodus = true
  print_linear_residuals = true
[]

[Debug]
  show_var_residual_norms = true
[]
