[Mesh]
  type = GeneratedMesh
  dim = 1
  nx = 40
  xmax = 40
[]

[MeshModifiers]
  [subdomain1]
    type = SubdomainBoundingBox
    bottom_left = '20 0 0'
    block_id = 1
    top_right = '40 1.0 0'
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

[AuxVariables]
  [T]
    block = '0 1'
  []
[]

[Kernels]
  inactive = 'source_u'
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
  [diff_u_dt]
    type = TimeDerivative
    variable = u
    block = '0'
  []
  [diff_v_dt]
    type = TimeDerivative
    variable = v
    block = '1'
  []
  [source_u]
    type = BodyForce
    variable = u
    block = '0'
  []
  [Liquid_Ln_solute_Soret_Diffusion]
    # Materials Properties
    type = SoretDiffusion
    variable = v
    block = '1'
    diff_name = D # Get diffusity from this block
    Q_name = Qheat_liquid # In [Material] Block below, Provide the transport heat
    T = 'T'
  []
  [Solid_Ln_solute_Soret_Diffusion]
    # Materials Properties
    type = SoretDiffusion
    diff_name = D
    Q_name = Qheat_liquid
    T = 'T'
    variable = u
    block = '0'
  []
[]

[InterfaceKernels]
  [interface]
    type = InterfaceDiffusion
    variable = u
    neighbor_var = 'v'
    boundary = 'master0_interface'
    D = D # Get material D from master
    D_neighbor = D # Get material D from neighbor
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

[AuxKernels]
  [Temperature_Interpolation]
    # # use a Parsedfunction to calculate the Temperature, this is Operate on T
    type = FunctionAux
    variable = T
    function = Temp_Interpolation
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
  inactive = 'stateful'
  [stateful]
    # Initialize diffusivity, not needed for now.
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
  [Qheat_liquid]
    type = GenericConstantMaterial
    prop_names = 'Qheat_liquid'
    prop_values = '1.0'
    block = '0 1'
  []
[]

[Functions]
  [Temp_Interpolation]
    type = ParsedFunction
    value = 'origin_temp + gradient_x * abs(x - startpoint_x)'
    vars = 'origin_temp startpoint_x gradient_x'
    vals = '855 0.0 -0.05'
  []
[]

[Preconditioning]
  [smp]
    type = SMP
    full = true
  []
[]

[Executioner]
  type = Transient
  num_steps = 100
  dt = 1
  solve_type = NEWTON
[]

[Outputs]
  # csv = true
  exodus = true
  print_linear_residuals = true
[]

[Debug]
  show_var_residual_norms = true
[]
