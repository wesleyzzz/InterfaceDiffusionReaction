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

[AuxVariables]
  [T]
    block = '0 1'
  []
[]

[Kernels]
  # ## SoretDiffusion
  [diff_u]
    type = CoeffParamDiffusion
    variable = u
    D = 4
    block = '0'
  []
  [diff_v]
    type = CoeffParamDiffusion
    variable = v
    D = 2
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
  [liquid_Ln_solute_Soret_Diffusion]
    # Materials Properties
    type = SoretDiffusion
    variable = v
    block = '1'
    diff_name = D # Get diffusity from this block
    Q_name = Qheat_liquid # In [Material] Block below, Provide the transport heat
    T = 'T'
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

[AuxKernels]
  [Temperature_Interpolation]
    # # use a Parsedfunction to calculate the Temperature
    type = FunctionAux
    variable = T
    function = Temp_Interpolation
  []
[]

[BCs]
  [left]
    type = NeumannBC
    variable = u
    boundary = 'left'
  []
  [right]
    type = NeumannBC
    variable = v
    boundary = 'right'
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
  [Qheat_liquid]
    type = GenericConstantMaterial
    prop_names = 'Qheat_liquid'
    prop_values = '1.0'
    block = '1'
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
  num_steps = 10
  dt = 0.1
  solve_type = NEWTON
[]

[Outputs]
  exodus = true
  print_linear_residuals = true
[]

[Debug]
  show_var_residual_norms = true
[]
