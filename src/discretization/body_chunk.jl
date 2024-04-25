struct BodyChunk{System<:AbstractSystem,
                 Material<:AbstractMaterial,
                 Params<:AbstractParameterSetup,
                 Storage<:AbstractStorage} <: AbstractBodyChunk{System,Material}
    system::System
    mat::Material
    paramsetup::Params
    storage::Storage
    ch::ChunkHandler
    psets::Dict{Symbol,Vector{Int}}
    sdbcs::Vector{SingleDimBC}
    pdsdbcs::Vector{PosDepSingleDimBC}
    cells::Vector{MeshCell{VTKCellType, Tuple{Int64}}}
end

function BodyChunk(body::AbstractBody, solver::AbstractTimeSolver, pd::PointDecomposition,
                   chunk_id::Int, param_spec::AbstractParamSpec)
    mat = body.mat
    system, ch = get_system(body, pd, chunk_id)
    paramsetup = init_params(body, ch, param_spec)
    storage = init_storage(mat, solver, system, ch)
    psets = localized_point_sets(body.point_sets, ch)
    sdbcs = body.single_dim_bcs
    pdsdbcs = body.posdep_single_dim_bcs
    cells = get_cells(ch.n_loc_points)
    return BodyChunk(system, mat, paramsetup, storage, ch, psets, sdbcs, pdsdbcs, cells)
end

@inline function get_params(b::BodyChunk, point_id::Int)
    return get_params(b.paramsetup, point_id)
end

@inline get_system_type(::BodyChunk{Sys,M,P,S}) where {Sys,M,P,S} = Sys
@inline get_material_type(::BodyChunk{Sys,M,P,S}) where {Sys,M,P,S} = M
@inline get_storage_type(::BodyChunk{Sys,M,P,S}) where {Sys,M,P,S} = S

@inline function get_system_type(vb::Vector{BodyChunk})
    return get_system_type(first(vb))
end

@inline function get_material_type(vb::Vector{BodyChunk})
    return get_material_type(first(vb))
end

@inline function get_storage_type(vb::Vector{BodyChunk})
    return get_storage_type(first(vb))
end

@inline function body_chunk_type(body::AbstractBody{Material}, solver::AbstractTimeSolver,
                                 param_spec::AbstractParamSpec) where {Material}
    System = system_type(body.mat)
    Params = parameter_setup_type(body, param_spec)
    Storage = storage_type(body, solver)
    return BodyChunk{System,Material,Params,Storage}
end

@inline each_point_idx(b::AbstractBodyChunk) = each_point_idx(b.ch)